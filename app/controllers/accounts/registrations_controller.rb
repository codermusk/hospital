# frozen_string_literal: true

class Accounts::RegistrationsController < Devise::RegistrationsController
  def create
    build_resource(sign_up_params)
    patient = Patient.new(patient_params)
    if patient.save!
      resource.accountable_id = patient.id
      resource.accountable_type = "Patient"
      resource.save
      if !resource.persisted?
        patient.destroy
      end
    end

    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else

      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  def patient_params
    params.require(:patient).permit(:name , :age , :sex  , :mobile_number)
  end

end
