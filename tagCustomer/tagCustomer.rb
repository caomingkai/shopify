#!/usr/bin/env ruby
#-----------------------------------------------
# 1. these 'require' sentences are like JAVA import
#    to import a block of code with specific functionality
# 2. In order to use these gem, we have to install these gems
#    onto local env. Here comes gemfile and bundler.
#    gemfile: list out the required gem in the gemfile
#    bundler: use 'bundle' command to install gems listed in
#    gemfile
# 3. This script have only web-client function, not web-server function; that is to say
#    it only GET/POST info to Shopify server, but cannot handle GET/POST request from others
# 4. This script is only a script, not function as a back-end script,
#    because it doesn't associate with a server, thus cannot handle GET/POST request
#    from web clients.
#-----------------------------------------------
require 'pry'
require 'shopify_api'   # this is code for shopify REST calls
require 'dotenv'        # this is for load environment var, like apikey/ api password
require 'sinatra'
require 'httparty'

Dotenv.load             # load .env file, so the ENV var in Ruby can access to those var


class TagCustomers < Sinatra::Base
    attr_accessor :shop_url  # make instance variable @shop_url can be 'get' and 'set'
    
    # Configure the Shopify connection
    def initialize                     # when .new, we build up the connect, that is to say,
        # the ShopifyAPI::Base obj knows which shop to get data
        @shop_url = "https://#{ENV["SHOPIFY_API_KEY"]}:#{ENV["SHOPIFY_PASSWORD"]}@#{ENV["SHOP"]}.myshopify.com/admin"
        super
        ShopifyAPI::Base.site = @shop_url
    end

    get '/a' do
        "This is HomePage"
        " this is a test from MINGKAI CAO"
    end


    post '/storefront_access_tokens' do
        
    end

    helpers do
        
    
        # Tests the Shopify connection with a simple GET request
        def test_connection
            return ShopifyAPI::Shop.current
        end
    
        def customers
            ShopifyAPI::Customer.all
        end
    
        def tag_repeat_customers
            tagged_customers = []
            customers.each do |customer|
                customer.tags += "tagCustomerApp"
                customer.save
                if customer.orders_count > 1
                    unless customer.tags.include?("repeat")
                        customer.tags += "repeat"
                        #------------------------------------------------
                        # 因为Shopify_API gem依赖使用ActiveRecord gem,因此
                        # 由shopifyAPI获得的数据可以直接CRUD
                        # 一、《创建》
                        # 1. new 方法创建一个新对象，create 方法创建新对象，并将其存入数据库。
                        # 2. save 方法可以把记录存入数据库。
                        # 二、《读取》
                        # 3. all 方法返回所有用户组成的集合
                        # 4. first 方法返回第一个用户
                        # 5. User.find_by(name: 'David') 返回第一个名为 David 的用户
                        # 6. users = User.where(name: 'David', occupation: 'Code Artist').order(created_at: :desc)
                        # 查找所有名为 David，职业为 Code Artists 的用户，而且按照 created_at 反向排列
                        # 三、《更新》
                        # 1. user = User.find_by(name: 'David')
                        #    user.update(name: 'Dave')
                        # 2. User.update_all "max_login_attempts = 3, must_change_password = 'true'"
                        # 四、《删除》
                        # user = User.find_by(name: 'David')
                        # user.destroy
                        #-------------------------------------------------                    customer.save
                    
                    end
                    tagged_customers << customer
                end
            end
        
            tagged_customers
        end
    end
end

# Called when the file is run on the command line, but not in a require

=begin
 
if __FILE__ == $PROGRAM_NAME
    a = TagCustomers.new
    puts a.test_connection.inspect
    #puts TagCustomers.new.test_connection.inspect # Prints the result
    puts "----------------"
    #-----------------------------------------------
    # 'a' is the instance from new() method by TagCustomer class
    # so we can access its method, such as 'test_connection' or 'customers'
    # also, for the return value, we can directly append its instance varible to get its value
    # and also we could directly append index to get record accordingly
    # like below, a.customer return value is array, so we can directly use a.customers[0]
    # since a.customers[0] is an object like below, we could again use . to access its attributes, ie. 'id','email','accepts_marketing'; but for hash varible, we must use ["key"] to access it value
    # Below is customer object:
    #  <ShopifyAPI::Customer:0x007ffd79911aa8
    #    @attributes={
    #        "id"=>6410576853,
    #        "email"=>"Mathilde.Cruickshank@data-generator.com",
    #        "accepts_marketing"=>false,
    #        "created_at"=>"2017-07-08T13:58:56-04:00",
    #    },
    #    @prefix_options={},
    #    @persisted=true
    #   >
    #-----------------------------------------------
    puts a.customers[0].first_name
    a.tag_repeat_customers
    a.customers.each do |customer|
        puts customer.tags
        end
end
 
=end

TagCustomers.#{ENV["SHOPIFY_API_KEY"]}
run TagCustomers.run!



