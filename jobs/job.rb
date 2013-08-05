pics = %w[car castle city dog leaf pink snow soccer water]
img_root = development? ? '/assets/' : ''
img_ext  = development? ? '.jpg' : ''

SCHEDULER.every '5s' do
  send_event('trending-img', { url: "#{img_root}#{pics.sample}#{img_ext}" })
end
