module Cukunity
  module SpecHelpers 
    def should(negation, target, *args)
      if negation
        target.should_not *args
      else
        target.should *args
      end
    end

    def should_equal(negation, target, arg)
      if negation
        target.should_not == arg
      else
        target.should == arg
      end
    end
  end
end

World(Cukunity::SpecHelpers)
