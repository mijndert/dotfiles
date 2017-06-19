
module.exports =
class WordcountView
  CSS_SELECTED_CLASS: 'wordcount-select'

  constructor: ->
    @element = document.createElement 'div'
    @element.classList.add('word-count')
    @element.classList.add('inline-block')

    @divWords = document.createElement 'div'

    @element.appendChild(@divWords)


  update_count: (editor) ->
    texts = @getTexts editor
    wordCount = charCount = 0
    for text in texts
      [words, chars] = @count text
      wordCount += words
      charCount += chars
    @divWords.innerHTML = "#{wordCount || 0} W"
    @divWords.innerHTML += (" | #{charCount || 0} C") unless atom.config.get('wordcount.hidechars')
    priceResult = wordCount*atom.config.get('wordcount.wordprice')
    @divWords.innerHTML += (" | #{priceResult.toFixed(2) || 0} ")+atom.config.get('wordcount.currencysymbol') if atom.config.get('wordcount.showprice')
    if goal = atom.config.get 'wordcount.goal'
      if not @divGoal
        @divGoal = document.createElement 'div'
        @divGoal.style.width = '100%'
        @element.appendChild @divGoal
      green = Math.round(wordCount / goal * 100)
      green = 100 if green > 100
      color = atom.config.get 'wordcount.goalColor'
      @divGoal.style.background = '-webkit-linear-gradient(left, ' + color + ' ' + green + '%, transparent 0%)'
      percent = parseFloat(atom.config.get 'wordcount.goalLineHeight') / 100
      height = @element.clientHeight * percent
      @divGoal.style.height = height + 'px'
      @divGoal.style.marginTop = -height + 'px'

  getTexts: (editor) =>
    # NOTE: A cursor is considered an empty selection to the editor
    texts = []
    selectionRanges = editor.getSelectedBufferRanges()
    emptySelections = true
    for range in selectionRanges
      text = editor.getTextInBufferRange(range)

      # Text from buffer might be empty (no selection but a cursor)
      if text
        texts.push(text)
        emptySelections = false

    # No or only empty selections will cause the entire editor text to be returned instead
    if emptySelections
      texts.push(editor.getText())
      @element.classList.remove @CSS_SELECTED_CLASS
    else
      @element.classList.add @CSS_SELECTED_CLASS

    texts

  count: (text) ->
    if atom.config.get('wordcount.ignorecode')
      codePatterns = [/`{3}(.|\s)*?(`{3}|$)/g, /[ ]{4}.*?$/gm]
      for pattern in codePatterns
        text = text?.replace pattern, ''
    words = text?.match(/\S+/g)?.length
    text = text?.replace '\n', ''
    text = text?.replace '\r', ''
    chars = text?.length
    [words, chars]
