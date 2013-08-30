require 'redcarpet'

$id_count = -1
class OurHTML < Redcarpet::Render::HTML
  def header(text, level)
    h_level = level + 1
    $id_count += 1
    "<h#{h_level} id=\"toc_#{$id_count}\">#{text}</h#{h_level}>"
  end
end


class PostsController < ApplicationController

  def page
    ### 如果传递了 p 参数，则重定向
    if params[:p].to_i > 0
      # 下面这种链接写死了，不大好，后续需要学习改进
      id = params[:p].to_i
      redirect_to "/posts/#{id}", status: 301
      return
    end

    # @posts = Post.page(params[:page]).per(1)
    @posts = Post.order("created_at DESC").first(10)
    @first_title = @posts[0].title
    @first_text = md(@posts[0].text)
    @first_time = @posts[0].created_at
    @first_id = @posts[0].id
    render 'page'
  end

  def index
    # @posts = Post.all(:page => params[:page]) 
    @posts = Post.page(params[:page]).per(10).order("created_at DESC")
  end

  def new
    # cookies.permanent[:user] = "hick"
    valid()

    # 注意这里的变化
    @post = Post.new
  end

  def show
    @post = Post.find(params[:id])
    @post.text = md(@post.text)
  end

  ## 根据 title 查找
  def title
    @post = Post.where("title = ?", params[:title]).take
    @post.text = md(@post.text)
    render 'show'
  end

  ## 根据 entitle 查找
  def entitle
    @post = Post.where("entitle = ?", params[:title]).take
    @post.text = md(@post.text)
    render 'show'
  end

  def create
    valid()
    # render text: params[:post].inspect
    @post = Post.new(params[:post].permit(:title, :entitle, :keywords, :text))
    if @post.save
      redirect_to @post
    else
      render 'new'
    end
  end

  ### 修改文章页面
  def edit
    valid()
    @post = Post.find(params[:id])
  end

  ### 修改文章操作
  def update
    valid()

    @post = Post.find(params[:id])

    if @post.update(params[:post].permit(:title, :entitle, :keywords, :text))
      redirect_to @post
    else
      render 'edit'
    end
  end

  ### 删除文章
  def destroy
    valid()

    @post = Post.find(params[:id])
    @post.destroy

    redirect_to posts_path
  end

  ### 简单校验
  def valid
    if cookies[:user] != "hick"
      redirect_to posts_path
    end
  end

  ### 转换 markdown 格式
  def md(str)

    ### 生成 toc 
    html_toc = Redcarpet::Markdown.new(Redcarpet::Render::HTML_TOC)
    toc  = html_toc.render(str)
    ### 渲染正文内容
    $id_count = -1  # 查了下没找到解决方案，先用这本办法解决全局变量的问题了(发现进程/请求之间有共享)
    markdown = Redcarpet::Markdown.new(
      OurHTML.new(:with_toc_data => true, :link_attributes => Hash["target" => "_blank"]), 
      :autolink => true, :space_after_headers => true, :no_intra_emphasis => true,
      :tables => true
    )
    toc.to_s + markdown.render(str)
  end

  private
    def post_params
      params.require(:post).permit(:title, :entitle, :keywords, :text)
      
    end
end
