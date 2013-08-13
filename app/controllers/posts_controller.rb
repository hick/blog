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

    ### 修改日志页面
    def edit
        @post = Post.find(params[:id])
    end

    ### 修改日志操作
    def update
        @post = Post.find(params[:id])

        if @post.update(params[:post].permit(:title, :entitle, :text))
            redirect_to @post
        else
            render 'edit'
        end
    end

    ### 删除日志
    def destroy
        @post = Post.find(params[:id])
        @post.destroy

        redirect_to posts_path
    end

    private
        def post_params
            params.require(:post).permit(:title, :entitle, :keywords, :text)
            
        end
end
