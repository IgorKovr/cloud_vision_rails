class Api::PicsController < ApplicationController
  respond_to :json
  skip_before_filter  :verify_authenticity_token

  def create

    file = params[:file]

    file_name = save_image_to_temp_file(file)

    # file_url = open(params[:file_url], :allow_redirections => :safe)

    if (file)
      responce =  GoogleCloudVision::Classifier.new('YOUR_API_KEY',
                                             [
                                                 # { image: './text.png', detection: 'TEXT_DETECTION', max_results: 10 },
                                                 { image: file_name, detection: 'LABEL_DETECTION', max_results: 10 }
                                             ]).response


      # TYPE_UNSPECIFIED
      # FACE_DETECTION
      # LANDMARK_DETECTION
      # LOGO_DETECTION
      # LABEL_DETECTION
      # TEXT_DETECTION
      # SAFE_SEARCH_DETECTION
      # IMAGE_PROPERTIES

      render json: responce, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end

  end

  def save_image_to_temp_file(file)
    extension = file.original_filename.split('.').last
    # Creating a temp file
    tmp_file = "./tmp/uploaded.#{extension}"
    id = 0
    while File.exists?(tmp_file) do
      tmp_file = "./tmp/uploaded-#{id}.#{extension}"
      id += 1
    end

    # Save to temp file
    File.open(tmp_file, 'wb') do |f|
      f.write file.read
    end

    return tmp_file
  end

end