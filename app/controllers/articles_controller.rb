class ArticlesController < ApplicationController
	before_action :authenticate_user!, except: [:show,:index]
	before_action :set_article, except: [:index,:new,:create,:pulish]
	before_action :authenticate_editor!, only: [:new,:create,:update]
	before_action :authenticate_admin!, only: [:destroy,:pubish]

	#GET /articles
	def index
		@articles = Article.paginate(page: params[:page], per_page:9).publicados.ultimos
		#@articles_count = Article.group(:user_id).count
		#@user = User.group_by_day(:created_at).count
		@articles_num = Article.group(:id).sum(:visits_count)
		@articles_count = User.includes(:articles).group("articles.user_id").pluck("users.email, count(articles.id)")
		respond_to do |format|
	      format.html
	      format.pdf do
	        render :pdf => "report", :layout => 'pdf.html.haml'
	      end
	    end
	end
	#GET /articles/:id
	def show
		@article.update_visits_count
		@comment = Comment.new
	end

	#GET /articles/new
	def new
		@article = Article.new
		@categories = Category.all
	end

	def edit

	end


	def update

		if @article.update(article_params)
			redirect_to @article
		else
			render :edit
		end
	end

	#POST /articles
	def create
		@article = current_user.articles.new(article_params	)
		#raise params.to_yaml
		@article.categories = params[:categories]

		if @article.save
			redirect_to @article
		else
			render :new
		end
	end

	def destroy
		@article.destroy
		redirect_to articles_path
	end

	def publish
		@article.publish!
		redirect_to @article
	end

	def unpublish
		@article.unpublish!
		redirect_to @article
	end

	private

	def set_article
		@article = Article.find(params[:id])
	end

	def article_params
		params.require(:article).permit(:title,:body,:cover,:categories,:markup_body)
	end
end
