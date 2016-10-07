require 'jrubyfx'

class Calculator

  FIRST, SECOND=0, 1
  ADDITION, SUBTRACTION, MULTIPLICATION, DIVISION, NEGATE, COMPUTE, SQRT, INVERT, SIN, COS, NONE=0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10

  attr_accessor :decimalPartInput

  java_import 'javafx.beans.property.SimpleStringProperty'

  property_accessor :result

  def reset ()
    @decimalPartInput, @cursor, @currentOperation, @lastOperation, @doneCalculating= false, FIRST, NONE, NONE, false
    @result.setValue('0')
    @operands=[@result.value.to_f, 0.to_f]
  end

  def initialize
    @result=SimpleStringProperty.new('0')
    reset()
  end

  def evaluate(operation)

    case operation
      when ADDITION then
        @result.setValue(convertNumberToString(@operands[0]+@operands[1]))
        terminateOperation()

      when SUBTRACTION then
        @result.setValue(convertNumberToString(@operands[0]-@operands[1]))
        terminateOperation()

      when MULTIPLICATION then
        @result.setValue(convertNumberToString(@operands[0]*@operands[1]))
        terminateOperation()

      when DIVISION then
        if @operands[SECOND] != 0
          @result.setValue(convertNumberToString(@operands[0]/@operands[1]))
          terminateOperation()
        end

      when NEGATE then
        @result.setValue(convertNumberToString(@operands[@cursor]=-1*@operands[@cursor]))
        @doneCalculating=true
      when SQRT then
        if @operands[@cursor]>0
          @result.setValue(convertNumberToString(@operands[@cursor]=Math.sqrt(@operands[@cursor])))
          @doneCalculating=true
        end

      when INVERT then
        if @operands[@cursor]!= 0
          @result.setValue(convertNumberToString (@operands[@cursor]=1.to_f / @operands[@cursor]))
          @doneCalculating=true
        end

      when SIN then
        @result.setValue(convertNumberToString(@operands[@cursor]=Math.sin(@operands[@cursor])))
        @doneCalculating=true

      when COS then
        @result.setValue(convertNumberToString(@operands[@cursor]=Math.cos(@operands[@cursor])))
        @doneCalculating=true
    end


  end

  def addDigit (c)
    if (@doneCalculating)
      @result.setValue(convertNumberToString(@operands[@cursor]=0))
      @doneCalculating=false
    end
    if @decimalPartInput
      c='.'+c
      @decimalPartInput=false
    end
    operand= convertNumberToString @operands[@cursor]
    if (operand+c)=~/^[+-]?\d+(\.\d+)?$/
      operand << c
      @result.setValue(convertNumberToString(@operands[@cursor]=operand.to_f))
    end
  end

  def removeLastDigit
    if @decimalPartInput then
      @decimalPartInput=false
    end
    if @operands[@cursor]==0 then
      return
    end
    operand= convertNumberToString @operands[@cursor]
    if operand.size==1
      operand='0'
    else
      operand.slice!(-1)
      if operand[-1]=='.' then
        operand.slice!(-1)
      end
    end

    if (operand)=~/^[+-]?\d+(\.\d+)?$/
      @result.setValue(convertNumberToString(@operands[@cursor]=operand.to_f))
      end

      end

      def setCurrentOperation (operation)
        if ([ NEGATE, SQRT, INVERT, SIN, COS].include? operation)
          evaluate(operation)
        else
          if (operation==COMPUTE && @currentOperation!=NONE)
            puts "before *********compute operation : #{@currentOperation}  cursor : #{@cursor}"
            evaluate(@currentOperation)
            @currentOperation=NONE
            @cursor = FIRST
            puts "after *********compute operation : #{@currentOperation}  cursor : #{@cursor}"
      else
        if (@currentOperation!=NONE && @cursor==SECOND)
          puts "before *********compute operation : #{@currentOperation}  cursor : #{@cursor}"
          evaluate(@currentOperation)
          @currentOperation=operation
          puts "after *********compute operation : #{@currentOperation}  cursor : #{@cursor}"
        else
          @cursor=SECOND
          @currentOperation=operation
        end
      end
    end
  end

  def terminateOperation()
    @decimalPartInput=false
    @operands=[@result.value.to_f, 0.to_f]
    @doneCalculating=true
  end


  def convertNumberToString n
    (n == n.to_i) ? n.to_i.to_s : n.to_f.to_s
  end


  def enterDecimalPart
    @decimalPartInput=true
    if (@doneCalculating)
      @result.setValue(convertNumberToString(@operands[@cursor]=0))
      @doneCalculating=false
    end
  end

  def handleInput(input)
    case input
      when '.' then
        @decimalPartInput=true
      when '+' then
        setCurrentOperation(Calculator::ADDITION)
      when '-' then
        setCurrentOperation(Calculator::SUBTRACTION)
      when '/' then
        setCurrentOperation(Calculator::DIVISION)
      when '*' then
        setCurrentOperation(Calculator::MULTIPLICATION)
      when ('0'..'9') then
        addDigit(input)
      when '=' then
        setCurrentOperation(Calculator::COMPUTE)
      when 'c', 'ce' then
        reset
      when '+/-' then
        setCurrentOperation(Calculator::NEGATE)
      when 'root' then
        setCurrentOperation(Calculator::SQRT)
      when '1/x' then
        setCurrentOperation(Calculator::INVERT)
      when 'sin' then
        setCurrentOperation(Calculator::SIN)
      when 'cos' then
        setCurrentOperation(Calculator::COS)
      when '<-' then
        removeLastDigit
      else
        'not implemented yet'
    end
  end

end #end of calculator

