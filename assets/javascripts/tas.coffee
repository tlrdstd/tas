lastEvents = {}

source = new EventSource('/events')
source.addEventListener 'open', (e) ->
  console.log("Connection opened")

source.addEventListener 'error', (e)->
  console.log("Connection error")
  if (e.readyState == EventSource.CLOSED)
    console.log("Connection closed")

source.addEventListener 'message', (e) ->
  data = JSON.parse(e.data)
  if lastEvents[data.id]?.updatedAt != data.updatedAt
    console.log("Received data for #{data.id}", data)
    lastEvents[data.id] = data
    $(document).trigger('tas.' + data.id, data)
    #if widgets[data.id]?.length > 0
    #  for widget in widgets[data.id]
    #    widget.receiveData(data)

updateColors = (colors) ->
  tas = {}
  panel = $(".tas-img-container")
  colors = $.colorThief.getPalette(panel.find('img').get(0), 10, 10)
  $.each colors, (i, code) ->
    color = $.Color(code)
    unless tas.primary? || color.light()
      tas.primary = color.toRgbaString()
      return

    unless tas.secondary? || color.dark()
      tas.secondary = color.toRgbaString()
      return

    unless tas.tertiary? || color.dark()
      tas.tertiary = color.toRgbaString()
      return

  $('body').animate(backgroundColor: tas.primary, 1000)
  panel.find('.tas-img-panel').animate(backgroundColor: tas.secondary, 1000)
  $('.navbar').animate(backgroundColor: tas.tertiary, 1000)


$(document).ready ->
  setTimeout updateColors, 1000

  $(document).on 'tas.trending-img', (e, data) ->
    $('#trending-img').attr src: data.url
    console.log('caught event', data)

