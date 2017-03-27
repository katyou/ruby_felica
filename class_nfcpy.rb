# #ここも自分のサーボにあったものに書き換える
# #s03t-2bbmg servo
# UNLOCK_ANGLE = "91"
# LOCK_ANGLE = "40"
#
# AUTO_LOCK = 40

class User
  def initialize(name = nil, idm = nil, present = 0)
    @name = name
    @exit_idm = idm
    @current_present = present

    #一時的な情報保持のためのインスタンス変数
    @unlock_user = nil
    @current_idm = nil
  end

  def hello
    puts ("Hello #{@name}")
  end

  def searching_idm(get_idm)
    if @exit_idm == get_idm# success
      @unlock_user = @name
      @current_idm = @exit_idm
      puts ("tenko coffee #{@unlock_user}")
    end

    unless @unlock_user == nil#
      if @current_present == 0
        print("Good Morning #{@unlock_user}!\n")
        puts("Let's do our best today!")
        start_file(@unlock_user)
        @current_present = 1
      else
        print("Good lack #{@unlock_user}!\n")
        puts("Let's do our best tomorrow!")
        finish_file(@unlock_user)
        @current_present = 0
      end
    end
  end
end

def idm(text)
  m = text.match(/ID=(.*?)\s/)
  get_idm = m[1]
  print("IDm = #{get_idm}\n")
  return get_idm
end

def nfc()
  #ここに自分の環境にあったものを指定
  `python ~/Desktop/practice_file/nfcpy/examples/tagtool.py`
end

def start_file(unlock_user)
  time = Time.now
  File.open("#{unlock_user}.csv", "a") do |f|
    f.puts("出社時間")
    f.print(time.year, "年", time.month, "月", time.day, "日", time.min, "分")
  end
end

def finish_file(unlock_user)
  time = Time.now
  File.open("#{unlock_user}.csv", "a") do |f|
    f.puts("退社時間")
    f.print(time.month, "月", time.day, "日", time.hour, "時", time.min, "分")
  end
end

#user確認よう
masahiro = User.new( name = "masahiro", idm = "011606000A10FE00", present = 0 ) #presentを@current_presentの値を入れる
ienaga   = User.new( name = "ienaga",   idm = "1111111", present = 0 )
mitsuko  = User.new( name = "mitsuko",  idm = "1111111111", present = 0 )

users = [masahiro, ienaga, mitsuko]


loop do
  user_id = idm(nfc)

  users.each do |user|
    user.searching_idm(user_id)
  end

  print("Please wait reader restart...\n")
  sleep(2)

end
