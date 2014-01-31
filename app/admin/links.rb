ActiveAdmin.register Link do
  permit_params :network, :channel, :line, :sender, :mirror_uri
end
