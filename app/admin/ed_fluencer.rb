ActiveAdmin.register EdFluencer do

  permit_params :title, :first_name, :last_name, :content, :image, :facebook, :twitter, :linkedIn, :website, :article
  
   form partial: 'form'
end
