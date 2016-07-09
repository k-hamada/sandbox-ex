defmodule Bookmarks.Router do
  use Bookmarks.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Bookmarks do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/bookmarks", BookmarkController
    get "/tags", TagController, :index
    get "/tags/:id", TagController, :show
    delete "/tags/:id", TagController, :delete
    get "/tag/:tag", TagController, :show_tag
  end

  # Other scopes may use custom stacks.
  # scope "/api", Bookmarks do
  #   pipe_through :api
  # end
end
