module SequenceServer
  # Module to contain methods for dealing with taxonomic hierarchy.
  class Hierarchy
  
    def initialize (root = 'Lepidoptera')
    	@root = root
    end
    
  	def parents
      par = {
        'agraulis' => 'Butterflies',
  	    'bicyclus' => 'Butterflies',
  	    'bombyx' => 'Moths',
  	    'chilo' => 'Moths',
  	    'danaus' => 'Butterflies',
  	    'eueides' => 'Butterflies',
  	    'heliconius' => 'Butterflies',
  	    'laparus' => 'Butterflies',
  	    'lerema' => 'Butterflies',
  	    'manduca' => 'Moths',
  	    'melitaea' => 'Butterflies',
  	    'neruda' => 'Butterflies',
  	    'papilio' => 'Butterflies',
  	    'pieris' => 'Butterflies',
  	    'plodia' => 'Moths',
  	    'plutella' => 'Moths'
  	  }
  	  par.default = 'Lepidoptera'
  	  return par
    end
    
    def nesting(name)
      parents[name]
    end
    
  end
end

