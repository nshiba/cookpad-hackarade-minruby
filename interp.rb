require "minruby"

# An implementation of the evaluator
def evaluate(exp, env, fdef)
  # pp(exp)
  # exp: A current node of AST
  # env: An environment (explained later)

  case exp[0]
#
## Problem 1: Arithmetics
#

  when "lit"
    exp[1] # return the immediate value as is

  when "+"
    evaluate(exp[1], env, fdef) + evaluate(exp[2], env, fdef)
  when "-"
    evaluate(exp[1], env, fdef) - evaluate(exp[2], env, fdef)
  when "*"
    evaluate(exp[1], env, fdef) * evaluate(exp[2], env, fdef)
  when "/"
    evaluate(exp[1], env, fdef) / evaluate(exp[2], env, fdef)
  when "%"
    evaluate(exp[1], env, fdef) % evaluate(exp[2], env, fdef)
  when ">"
    evaluate(exp[1], env, fdef) > evaluate(exp[2], env, fdef)
  when "<"
    evaluate(exp[1], env, fdef) < evaluate(exp[2], env, fdef)
  when ">="
    evaluate(exp[1], env, fdef) >= evaluate(exp[2], env, fdef)
  when "<="
    evaluate(exp[1], env, fdef) <= evaluate(exp[2], env, fdef)
  when "=="
    evaluate(exp[1], env, fdef) == evaluate(exp[2], env, fdef)
  
#
## Problem 2: Statements and variables
#

  when "stmts"
    i = 1
    last = nil
    while exp[i]
      last = evaluate(exp[i], env, fdef)
      i = i + 1
    end
    last

  when "var_ref"
    env[exp[1]]

  when "var_assign"
    env[exp[1]] = evaluate(exp[2], env, fdef)


#
## Problem 3: Branchs and loops
#

  when "if"
    if evaluate(exp[1], env, fdef)
      evaluate(exp[2], env, fdef)
    else
      evaluate(exp[3], env, fdef)
    end

  when "while"
    while evaluate(exp[1], env, fdef)
      evaluate(exp[2], env, fdef)
    end


#
## Problem 4: Function calls
#

  when "func_call"
    # Lookup the function definition by the given function name.
    func = fdef[exp[1]]

    if func == nil
      # We couldn't find a user-defined function definition;
      # it should be a builtin function.
      # Dispatch upon the given function name, and do paticular tasks.
      case exp[1]
      when "p"
        # MinRuby's `p` method is implemented by Ruby's `p` method.
        p(evaluate(exp[2], env, fdef))
      # ... Problem 4
      when "Integer"
        Integer(evaluate(exp[2], env, fdef))
      when "fizzbuzz"
        n = evaluate(exp[2], env, fdef)
        if n % 3 == 0
          if n % 5 == 0
            "FizzBuzz"
          else
            "Fizz"
          end
        else
          if n % 5 == 0
            "Buzz"
          end
        end
      when "require"
        # do noting
      when "minruby_parse"
        minruby_parse(evaluate(exp[2], env, fdef))
      when "minruby_load"
        minruby_load()
      else
        raise("unknown builtin function")
      end
    else

#
## Problem 5: Function definition
#

      # (You may want to implement "func_def" first.)
      #
      # Here, we could find a user-defined function definition.
      # The variable `func` should be a value that was stored at "func_def":
      # a parameter list and an AST of function body.
      #
      # A function call evaluates the AST of function body within a new scope.
      # You know, you cannot access a varible out of function.
      # Therefore, you need to create a new environment, and evaluate the
      # function body under the environment.
      #
      # Note, you can access formal parameters (*1) in function body.
      # So, the new environment must be initialized with each parameter.
      #
      # (*1) formal parameter: a variable as found in the function definition.
      # For example, `a`, `b`, and `c` are the formal parameters of
      # `def foo(a, b, c)`.
      # raise(NotImplementedError) # Problem 5

      i = 0
      fenv = {}
      while func[0][i]
        fenv[func[0][i]] = evaluate(exp[i+2], env, fdef)
        i = i + 1
      end
      evaluate(func[1], fenv, fdef)
    end

  when "func_def"
    # Function definition.
    #
    # Add a new function definition to function definition list.
    # The AST of "func_def" contains function name, parameter list, and the
    # child AST of function body.
    # All you need is store them into $function_definitions.
    #
    # Advice: $function_definitions[???] = ???
    # raise(NotImplementedError) # Problem 5
    fdef[exp[1]] = [exp[2], exp[3]]


#
## Problem 6: Arrays and Hashes
#

  # You don't need advices anymore, do you?
  when "ary_new"
    i = 0
    ary = []
    while exp[i+1]
      ary[i] = evaluate(exp[i+1], env, fdef)
      i = i + 1
    end
    ary

  when "ary_ref"
    # p exp
    ary = evaluate(exp[1], env, fdef)
    ary[evaluate(exp[2], env, fdef)]

  when "ary_assign"
    ary = evaluate(exp[1], env, fdef)
    ary[evaluate(exp[2], env, fdef)] = evaluate(exp[3], env, fdef)

  when "hash_new"
    hash = {}
    i = 1
    while exp[i]
      hash[evaluate(exp[i], env, fdef)] = evaluate(exp[i+1], env, fdef)
      i = i + 2
    end
    hash

  else
    p("error")
    pp(exp)
    raise("unknown node")
  end
end


function_definitions = {}
env = {}

# `minruby_load()` == `File.read(ARGV.shift)`
# `minruby_parse(str)` parses a program text given, and returns its AST
evaluate(minruby_parse(minruby_load()), env, function_definitions)
