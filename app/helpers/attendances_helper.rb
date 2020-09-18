module AttendancesHelper
  
  def attendance_attend(attendance)
    if Date.current == attendance.worked_on
      return '出社' if attendance.started_at.nil?
    end
    false
  end
  
  def attendance_leave(attendance)
    if Date.current == attendance.worked_on
      return '退社' if attendance.started_at.present? && attendance.finished_at.nil?
    end
    false
  end
  
  
  # 出勤時間と退勤時間を受け取り、在社時間を計算して返します。
  def working_times(start, finish)
    format("%.2f", (((finish - start) / 60) / 60.0))
  end
  
  def attendances_invalid?
    attendances = true
    attendances_params.each do |id, item|
      if item[:started_at].blank? && item[:finished_at].blank?
        next
      elsif item[:started_at].blank? || item[:finished_at].blank?
        attendances = false
        break
      elsif item[:started_at] > item[:finished_at]
        attendances = false
        break
      end
    end
    return attendances
  end
  
  # 本日の勤務中の社員取得用
  def working_users
    User.where(id: Attendance.where.not(started_at: nil).
         where(id: Attendance.where(finished_at: nil)).
         where(id: Attendance.where(worked_on: Date.current)).select(:user_id))
  end
  
  # １ヶ月の勤怠申請用
  def set_one_month_apply
    @user.attendances.where('worked_on >= ? and worked_on <= ?', @first_day, @last_day).order('worked_on')
  end
  
  # １ヶ月勤怠申請先の上長の選択されているか？
  def selected_superior?
    superior = true
    month_apply_params.each do |id, item|
      if item[:superior_id].blank? && [:month_apply].present?
        superior = false
      elsif item[:superior_id].present? && [:month_apply].present?
         superior = true
         break
      end
     end
     superior
  end
  
  # １ヶ月勤怠申請が自分にきているか？
  def has_apply?
    User.joins(:attendances).where(attendances: {superior_id: current_user.id}).where(attendances: {month_approval: 2})
  end
  
   
  # １ヶ月勤怠申請決裁の変更のチェックが入っているか?
  def month_confirmed_invalid?(status, month_check)
    if (status == "承認" || status == "否認") && month_check == "1"
      confirmed = true
    else
      confirmed = false
    end
    confirmed
  end
  
  # １ヶ月勤怠申請中の社員を取得
  def month_applying_employee
    User.joins(:attendances).where.not(attendances: {superior_id: nil}).where(attendances: {month_approval: 2}).distinct
  end
  
  # １ヶ月勤怠申請済の社員を取得
  def month_applicated_employee
    User.joins(:attendances).where.not(attendances: {superior_id: nil}).where(attendances: {month_approval: 3}).distinct
  end
  
  # 自分以外の上長
  def superior_without_me
    User.where(superior: true).where.not(id: current_user.id)
  end
  
  # 自分を含めた上長
  def superior_add_me
    User.where(superior: true)
  end
  
  # １ヶ月申請ボタンフォームのステータス表示
  def apply_status(status)
    case status
    when "申請中"
      "に申請中"
    when "承認"
      "から承認済"
    when "否認"
      "から否認"
    else
      "未"
    end
  end
  
  # １ヶ月申請ボタンフォームのステータス表示
  def apply_btn_status(status)
    case status
    when "申請中"
      "申請先を変更"
    when "承認"
      "再申請"
    when "否認"
      "再申請"
    else
      "申請"
    end
  end
end
