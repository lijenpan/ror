class HomeController < ApplicationController
  def index
    @pm_messages = Message.all
  end

  def faq
    @questions = Question.all
  end
end
