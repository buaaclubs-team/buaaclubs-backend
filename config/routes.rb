Rails.application.routes.draw do

  resources :comments
  resources :webmails
  resources :lists

  get '/api/articles/:article_id/comments' => 'articles#getcomments' # 获得当前文章评论

  post '/api/users/phone_num/verify/code' => 'users#verify_phone_sendcode'# 手机验证发送验证码
  post '/api/users/phone_num/verify' => 'users#verify_phone' # 验证验证码是否正确
  post 'GET /api/users/email/verify' => 'users#verify_email_send' # 验证邮箱，给邮箱寄信
  get '/api/users/email/verify/:hash_code' => 'users#verify_email' # 验证邮箱，邮箱点击链接返回

  post '/api/users/forgetpassword/email' => 'users#fp_email' # 忘记密码，邮箱
  get '/api/users/forgetpassword/email/verify/:hash_code' => 'users#fp_email_verify' # 忘记密码，邮箱转跳
  post '/api/users/forgetpassword/phone_num/send' => 'users#fp_phone_send' # 忘记密码，手机
  post '/api/users/forgetpassword/phone_num/verify' => 'users#fp_phone_verify' # 忘记密码，手机

  get '/api/clubs/members/all' => 'clubs#memberslist'#获取社团名单
  #发送通知
  post 'api/clubs/users/export' => 'clubs#exportlist' #导出名单
  post '/api/clubs/members/forcequit' => 'clubs#forcequit' #强制退社
  get '/api/clubs/members/apply' => 'clubs#applicantlist' #申请人列表
  get '/api/clubs/members/apply/accept/:user_id' => 'clubs#acceptapplication'#同意申请
  get '/api/clubs/member/apply/refuse/:user_id' => 'clubs#refuseapplication'#拒绝申请  

  resources :informs
  resources :applications


  #post '/api/clubs/sendmessage' => 'clubs#sendmessage'
  #post '/api/clubs/sendemail' => 'clubs#sendemail'
  get '/api/users/register/check/:uid' => 'user#checkuid'
  post '/api/register' => 'users#register'
  post '/api/clubs/login' => 'clubs#login'
  post '/api/users/login' => 'users#login'
  get '/api/articles/:page_id' => 'articles#abstracts'
  get '/api/articles/detail/:article_id' => 'articles#detail'
  get '/api/clubs/:uid/articles/:page_id' => 'clubs#getabstracts'
  get '/api/users/logout' => 'users#logout'
  get '/api/clubs/logout' => 'clubs#logout'
  post '/api/clubs/inform' => 'clubs#inform'  
  post '/api/clubs/articles/:article_id/comments/reply/:reply_id' => 'clubs#reply' 
  post '/api/users/articles/:article_id/comments/reply/:reply_id' => 'users#reply'  
  post '/api/users/webmails/readall' => 'users#readall'
  post '/api/clubs/webmails/readall' => 'clubs#readall'


  post '/api/clubs/articles/detail/create' => 'articles#create'
#  post '/api/clubs/articles/detail/:article_id/create_content' => 'articles#create_content'
  post '/api/clubs/articles/detail/:article_id/change' => 'articles#show'
  post '/api/clubs/articles/detail/:article_id/update' => 'articles#update'
  post '/api/clubs/articles/detail/:article_id/delete' => 'articles#destroy' 
  post '/api/clubs/articles/detail/:article_id/list' => 'articles#list'
  post '/api/clubs/articles/detail/:article_id/list/delete' => 'articles#cutlist'
  post 'api/users/:uid/articles/:article_id/notes/create' => 'notes#create'
  resources :notes
  resources :users
  resources :clubs
  resources :articles
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
