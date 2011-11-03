# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :log do
    network 'freenode'
    channel 'ruby'
    sender  'someone'
    line    'Lorem Ipsum and Blah'
  end
end
