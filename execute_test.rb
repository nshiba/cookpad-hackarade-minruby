require "minruby"

MY_PROGRAM = 'interp.rb'
Dir.glob("test#{ARGV[0]}*.rb").sort.each do |f|
  if f == "test4-4.rb"
    puts "\e[33m#{f} => skip\e[0m"
    next
  end

  correct = `ruby #{f}`
  answer = `ruby #{MY_PROGRAM} #{MY_PROGRAM} #{MY_PROGRAM} #{f}`
  # export RUBY_THREAD_VM_STACK_SIZE=400000000 が必要

  if correct == answer
    puts "\e[32m#{f} => OK!\e[0m"
  else
    puts "\e[31m#{f} => NG!\e[0m"
    puts "=== Expect ==="
    puts correct
    puts "=== Actual ==="
    puts answer
    code = File.read(f)
    puts "=== Test Program ==="
    puts code
    puts "=== AST ==="
    pp minruby_parse(code)
    break
  end
end