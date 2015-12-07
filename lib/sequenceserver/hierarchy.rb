module SequenceServer
  # Module to contain methods for dealing with taxonomic hierarchy.
  class Hierarchy
  
    def initialize 
    end
  
  	def parents
      {
        :default => 'Lepidoptera',
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
    end
    
    
  end
end

