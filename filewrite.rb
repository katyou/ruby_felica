#ここは先ほど表示させた自分のidmに書き変える
USERS = {"Masahiro" => "xxxxxxxxxxxxxxxx",
         "Hentaikamen" => "xxxxxxxxxxxxxxxx",
         "ryoutukankichi" => "xxxxxxxxxxxxxxxx"}


def idm
  idm = 3
  return idm
end

def users(idm)
  @name = USERS.key(idm)
end

loop do
  time = Time.now

  idm
  user = USERS.key(idm)

  print("hello#{user} konitiha")

  File.open("sample.csv", "a") do |f|
    f.print("hello")
    f.puts(time)
  end
  sleep 10
end
