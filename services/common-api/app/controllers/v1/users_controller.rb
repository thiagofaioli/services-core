module V1
  class UsersController < ApiBaseController
      before_action :authenticate_user!
      before_action :resource, except: %i[create]

      def create
        @resource = current_platform.users.new(permitted_attributes[])
      end

      # def create
      #   @address = CommonModels::Address.new(permitted_attributes(@address))
      #   @address.tap { |p| p.platform = current_platform }

      #   authorize @address
      #   @address.save

      #   return render json: @address.errors, status: 400 unless @address.valid?
      #   render json: { address_id: @address.id }
      # end

      # def update
      #   authorize resource
      #   resource.update_attributes(permitted_attributes(resource))
      #   resource.save

      #   return render json: resource.errors, status: 400 unless resource.valid?
      #   render json: { project_id: resource.id }
      # end

      private

      def resource
        @resource ||= CommonModels::User.find params[:id]
      end

      def policy(record)
        UserPolicy.new((current_user.presence||current_platform_user.presence), record)
      end

      def pundit_params_for(record)
        params.require(:user)
      end
  end
end
