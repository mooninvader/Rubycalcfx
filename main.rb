require_relative 'calculator.rb'
require 'jrubyfx'

class CalcFx < JRubyFX::Application
  BUTTON_SIZE, GAP=40, 5

  def initialize
    @calculator= Calculator.new
  end

  def start(stage)
    innerGrid=buildGrid
    with(stage, title: 'calculator', width: (BUTTON_SIZE+GAP+1)*5, height: (BUTTON_SIZE+GAP)*7, maximized: false, resizable: false) do
      layout_scene() do
        innerGrid
      end
      stage.scene.stylesheets << 'res/Login.css'
      show
    end

    setShortcuts(stage.scene)
  end

  def buildGrid
    buttons =[
        %w(ce c <- root 1/x),
        %w(1 2 3 / %),
        %w(4 5 6 * sin),
        %w(7 8 9 - cos),
        %w(+/- 0 . + =)
    ]

    vbox      =build(VBox, padding: build(Insets, 5))
    textField =build(TextField, text: 'rrrr', editable: false, alignment: Pos::CENTER_RIGHT, prefHeight: BUTTON_SIZE, disable: true)
    gridPane  =build(GridPane, hgap: GAP, vgap: GAP, alignment: Pos::CENTER, gridLinesVisible: false)

    textField.text_property.bind(@calculator.result_property)
    gridPane.add(textField, columnIndex: 0, eowIndex: 0, columnSpan: 5, rowSpan: 1)


    buttons.each_with_index { |line, line_index|
      line.each { |caption|
        button=build(Button, text: caption, prefWidth: BUTTON_SIZE, minHeight: BUTTON_SIZE)
        if (('0'..'9')=== button.text)
          button.id = 'numpad'
        end
        setButtonsActions(button)
        gridPane.addRow(line_index+1, button)
      }
    }

    vbox.children << textField << gridPane
    vbox
  end


  def setButtonsActions(button)
    button.set_on_action do |e|
      @calculator.handleInput(e.source.text)
    end
  end

  def setShortcuts scene
    scene.set_on_key_pressed do |keyEvent|
      case keyEvent.code
        when KeyCode::NUMPAD0, KeyCode::NUMPAD1, KeyCode::NUMPAD2, KeyCode::NUMPAD3, KeyCode::NUMPAD4, KeyCode::NUMPAD5,
            KeyCode::NUMPAD6, KeyCode::NUMPAD7, KeyCode::NUMPAD8, KeyCode::NUMPAD9 then
          @calculator.handleInput((keyEvent.code.to_s)[-1])
        when KeyCode::ENTER then
          @calculator.handleInput('=')
        when KeyCode::SUBTRACT then
          @calculator.handleInput('-')
        when KeyCode::ADD then
          @calculator.handleInput('+')
        when KeyCode::MULTIPLY then
          @calculator.handleInput('*')
        when KeyCode::DIVIDE then
          @calculator.handleInput('/')
        when KeyCode::DECIMAL then
          @calculator.handleInput('.')
        when KeyCode::BACK_SPACE then
          @calculator.handleInput('<-')
        when KeyCode::ESCAPE then
          @calculator.handleInput('c')
      end
    end
  end

end

puts (1..10).reduce(:*)


CalcFx.launch

