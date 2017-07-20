class Api::V1::UsersController < Api::V1::ApiBaseController
  # Creates User.
  # Create a user for authenticated account.
  # == Example Request
  # curl -i -H "Authorization: Token token=7LGWItoVYJmjCAMbdRHTSAtt" -X POST -d "user[name]=API User" -d "user[email]=email@api.com" -d "user[tag_list]= tester, new user" -d "attributes[phone]=+123456456" -d "attributes[custom_key]=custom_value" http://localhost:3000/api/v1/users
  # == Request Type:
  # POST
  # == Parameters:
  # [String] user[email] User's email (required)
  # [String] user[name] User's name (optional)
  # [String] user[tag_list] User's tags (optional)
  # [String] attributes[key] User's attributes (optional)
  def create
    user = @api_account.users.new(user_params)
    if user.save
      if params[:attributes].present?
        params[:attributes].keys.each do |key|
          user.user_attributes.create(key: key, value: params[:attributes][key])
        end
      end
      render json: {
          user: user.attributes.merge(tags: user.tag_list, atributes: user.user_attributes.pluck(:key, :value) )
      }, status: 200
    else
      render json: { errors: user.errors.messages }, status: 422
    end
  end

  # Requiered Paramaters for create a User
  def user_params
    params.require(:user).permit(:name, :email, :tag_list)
  end
end