class RelationshipsController < ApplicationController
  def create


    aida = User.find_by(id: 2)

    User.find_each do |user|
      user.follow(aida)
    end


    user = User.find(params[:followed_id])
    current_user.follow(user)
    redirect_to user_path(user)
  end

  def destroy
    user = Relationship.find(params[:id]).followed
    current_user.unfollow(user)
    redirect_to user_path(user)
  end

  def ajaxfollowunfollow
    user = User.find(params[:followed_id])
    current_user.follow(user)
    @current_user.update(follow_status: true)
    respond_to do |format|
      format.html
      format.json
    end
  end

end
