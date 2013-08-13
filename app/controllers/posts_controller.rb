class PostsController < ApplicationController

    def index
        @posts = Post.all
    end

    def new
        # 注意这里的变化
        @post = Post.new
    end

    def show
        @post = Post.find(params[:id])
    end

    def create
        # render text: params[:post].inspect
        @post = Post.new(params[:post].permit(:title, :entitle, :keywords, :text))
        if @post.save
            redirect_to @post
        else
            render 'new'
        end
    end

    private
        def post_params
            params.require(:post).permit(:title, :entitle, :keywords, :text)
            
        end
end
