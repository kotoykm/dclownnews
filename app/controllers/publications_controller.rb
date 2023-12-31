class PublicationsController < ApplicationController
  before_action :set_publication, only: %i[ show edit update destroy ]
  before_action :authenticate_user! #Autenticador de publicaciones
  ###############MULTIPLESEMOJISDECALAVERA##############
  before_action :set_comments, only: %i[ new edit create destroy update ]

  before_action only: [:new, :create, :edit, :update, :destroy] do #Restriccion 1
    authorize_request(["author", "admin"])
  end

  # GET /publications or /publications.json
  def index
    @publications = Publication.all
  end

  # GET /publications/1 or /publications/1.json
  def show
  end

  # GET /publications/new
  def new
    @publication = Publication.new
  end

  # GET /publications/1/edit
  def edit
  end

  # POST /publications or /publications.json
  def create
    @publication = Publication.new(publication_params)
    @publication.user_id = current_user.id #Recibidor implicito de autoria

    respond_to do |format|
      if @publication.save
        format.html { redirect_to publication_url(@publication), notice: "Publication was successfully created." }
        format.json { render :show, status: :created, location: @publication }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @publication.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /publications/1 or /publications/1.json
  def update
    respond_to do |format|
      if @publication.update(publication_params)
        format.html { redirect_to publication_url(@publication), notice: "Publication was successfully updated." }
        format.json { render :show, status: :ok, location: @publication }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @publication.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /publications/1 or /publications/1.json
  def destroy
    @publication.destroy

    respond_to do |format|
      format.html { redirect_to publications_url, notice: "Publication was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_publication
      # @publication = Publication.includes(:comments).find(params[:id])
      # @comment = Comment.new
      # @comments = @publication.comments.order(created_at: :desc)
      @publication = Publication.includes(:comments).find_by(id: params[:id])
      @comment = Comment.new
      @comments = @publication.comments.order(created_at: :desc) if @publication
    end

    def set_comments
      @comments = Comment.all.pluck(:content, :id)
    end

    # Only allow a list of trusted parameters through.
    def publication_params
      params.require(:publication).permit(:image, :title, :description, :user_id)
    end
end
