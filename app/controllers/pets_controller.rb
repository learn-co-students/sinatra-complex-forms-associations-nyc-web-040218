class PetsController < ApplicationController

  get '/pets' do
    @pets = Pet.all
    erb :'/pets/index'
  end

  get '/pets/new' do
    @owners = Owner.all
    erb :'/pets/new'
  end

  post '/pets' do
    @pet = Pet.create("name" => params[:pet_name])

    if params[:owner_id]
      @pet.owner_id = params[:owner_id]
      @pet.save
      @o = Owner.find(params[:owner_id])
      @o.pets << @pet
      @o.save
    end

    if !params[:owner_name].empty?
      @new_owner = Owner.create("name" => params[:owner_name])
      @new_owner.pets << @pet
      @new_owner.save
      @pet.owner_id = @new_owner.id
      @pet.save
    end
    redirect to "pets/#{@pet.id}"
  end

  get '/pets/:id' do
    @pet = Pet.find(params[:id])
    erb :'/pets/show'
  end

  get '/pets/:id/edit' do
    @owners = Owner.all
    @pet = Pet.find(params[:id])
    erb :'/pets/edit'
  end

  post '/pets/:id' do
    # binding.pry
    @pet = Pet.find(params[:id])
    @pet.update("name" => params[:pet_name])
    if params[:owner_id]
      @pet.update("owner_id" => params[:owner_id])
    end
    # binding.pry
    if !params[:owner][:name].empty?
      # binding.pry
      @new_owner = Owner.create("name" => params[:owner][:name])
      @new_owner.pets << @pet
      @new_owner.save
      @pet.update("owner_id" => @new_owner.id)
    end

    redirect to "pets/#{@pet.id}"
  end
end
