# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'
#csvファイルを扱うためのgemを読み込む

CSV.foreach('db/Patterns.csv', headers: true) do |row|
#foreachは、ファイル（Patterns.csv）の各行を引数として、ブロック(do~endまでを範囲とする『引数のかたまり』)を繰り返し実行する
#rowには、読み込まれた行が代入される

Pattern.create(:category => row['category'], :pattern_id => row['pattern_id'], :answer_1 => row['answer_1'], :answer_2 => row['answer_2'], :answer_3 => row['answer_3'], :answer_4 => row['answer_4'], :answer_5 => row['answer_5'], :answer_6 => row['answer_6'], :answer_7 => row['answer_7'], :answer_8 => row['answer_8'], :answer_9 => row['answer_9'], :answer_10 => row['answer_10'], :answer_11 => row['answer_11'], :answer_12 => row['answer_12'])
#Patternテーブルの各カラムに、各行のn番目の値を代入している。

end
