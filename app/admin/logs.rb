ActiveAdmin.register Log do
  permit_params :network, :channel, :line, :sender
end
