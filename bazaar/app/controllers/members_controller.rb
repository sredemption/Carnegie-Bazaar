class MembersController < ApplicationController
      before_filter :authorize, :except => [:new, :create]
    before_filter :isAdmin, :only => :index

  # GET /members
  # GET /members.xml
  def index
    @members = Member.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @members }
    end
  end

  # GET /members/1
  # GET /members/1.xml
  def show
    @member = Member.find(params[:id])
    if admin_or_user(@member)
    else
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @member }
    end
    end
   end

  # GET /members/new
  # GET /members/new.xml
  def new
  if session[:member_id]
            flash[:notice] = "You already have an account!"
            redirect_to :controller => 'user' , :action => 'login'

    else
      @member = Member.new
       respond_to do |format|
         format.html # new.html.erb
          format.xml  { render :xml => @member }

    end

  end

  end

  # GET /members/1/edit
  def edit
    @member = Member.find(params[:id])
    admin_or_user(@member)
  end

  # Copied from 'edit', for changing the password
  def pass
    @member = Member.find(params[:id])
    admin_or_user(@member)
  end


  # POST /members
  # POST /members.xml
  def create
    @member = Member.new(params[:member])

    respond_to do |format|
      if @member.save
        flash[:notice] = 'Member was successfully created.'
        format.html { redirect_to(@member) }
        format.xml  { render :xml => @member, :status => :created, :location => @member }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @member.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /members/1
  # PUT /members/1.xml
  def update
    @member = Member.find(params[:id])

    respond_to do |format|
      if @member.update_attributes(params[:member])
        flash[:notice] = 'Member was successfully updated.'
        format.html { redirect_to(@member) }
        format.xml  { head :ok }
      else
        if params[:action => "pass"]
          format.html { render :action => "pass" }
        else
          format.html { render :action => "edit" }
        end    
        format.xml  { render :xml => @member.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /members/1
  # DELETE /members/1.xml
  def destroy
  @member = Member.find(params[:id])

  if admin_or_user(@member)
  else

    items = Array.new
    transactions = Array.new
    transactions = Transaction.getMemberTransactions(@member.id)
    items = Item.getItemSeller(@member.id)
    for obj in items do
      obj.delete
    end
     for obj2 in transactions do
      obj2.delete
    end
    @member.destroy

    respond_to do |format|
      format.html { redirect_to(:controller => "user", :action => "logout") }
      format.xml  { head :ok }
    end
  end
  end
end