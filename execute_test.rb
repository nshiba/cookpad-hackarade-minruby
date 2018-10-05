MY_PROGRAM = 'interp.rb'

Dir.glob('test*.rb').sort.each do |f|
  correct = `ruby #{f}`
  answer = `ruby #{MY_PROGRAM} #{f}`

  result = correct == answer ? 'OK!' : 'NG'
  puts "#{f} => #{correct == answer ? 'OK!' : 'NG'}"

  if result == 'NG'
    break
  end
end
