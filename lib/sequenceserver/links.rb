module SequenceServer
  # Module to contain methods for generating sequence retrieval links.
  module Links
    require 'erb'

    # Provide a method to URL encode _query parameters_. See [1].
    include ERB::Util
    #
    alias_method :encode, :url_encode

    TITLE_PATTERN = /(.+?_.+?_.+?)_.+?\s(\S+)/
#	aa|Bombyx_mori|NP_6723934.1
#	cds|Bombyx_mori|NP_6723934.1
#	transcript|Bombyx_mori|NP_6723934.1
#	gene|Bombyx_mori|NM_6723934.1
#	ctg|Bombyx_mori|ctg1
#	scaf|Bombyx_mori|scaf1
#	chr|Bombyx_mori|chr1
    # Link generators return a Hash like below.
    #
    # {
    #   # Required. Display title.
    #   :title => "title",
    #
    #   # Required. Generated url.
    #   :url => url,
    #
    #   # Optional. Left-right order in which the link should appear.
    #   :order => num,
    #
    #   # Optional. Classes, if any, to apply to the link.
    #   :class => "class1 class2",
    #
    #   # Optional. Class name of a FontAwesome icon to use.
    #   :icon => "fa-icon-class"
    # }
    #
    # If no url could be generated, return nil.
    #
    # Helper methods
    # --------------
    #
    # Following helper methods are available to help with link generation.
    #
    #   encode:
    #     URL encode query params.
    #
    #     Don't use this function to encode the entire URL. Only params.
    #
    #     e.g:
    #         sequence_id = encode sequence_id
    #         url = "http://www.ncbi.nlm.nih.gov/nucleotide/#{sequence_id}"
    #
    #   querydb:
    #     Returns an array of databases that were used for BLASTing.
    #
    #   whichdb:
    #     Returns the database from which the given hit came from.
    #
    #     e.g:
    #
    #         hit_database = whichdb
    #
    # Examples:
    # ---------
    # See methods provided by default for an example implementation.

    def sequence_viewer
      accession  = encode self.accession
      database_ids = encode querydb.map(&:id).join(' ')
      url = "get_sequence/?sequence_ids=#{accession}" \
            "&database_ids=#{database_ids}"

      {
        :order => 0,
        :url   => url,
        :title => 'Sequence',
        :class => 'view-sequence',
        :icon  => 'fa-eye'
      }
    end

    def fasta_download
      accession  = encode self.accession
      database_ids = encode querydb.map(&:id).join(' ')
      url = "get_sequence/?sequence_ids=#{accession}" \
            "&database_ids=#{database_ids}&download=fasta"

      {
        :order => 1,
        :title => 'FASTA',
        :url   => url,
        :class => 'download',
        :icon  => 'fa-download'
      }
    end

	def lepbase
      return nil unless title.match(TITLE_PATTERN)
      assembly = Regexp.last_match[1]
      type = Regexp.last_match[2]
      accession = id
      assembly = encode assembly
      accession = encode accession
      colon = encode ':'
      url = "http://ensembl.lepbase.org/#{assembly}"
      if type == 'protein' || type == 'aa'
        url = "#{url}/Transcript/ProteinSummary?db=core;p=#{accession}"
      elsif type == 'cds' || type == 'transcript'
        url = "#{url}/Transcript/Summary?db=core;t=#{accession}"
      elsif type == 'gene'
      	url = "#{url}/Gene/Summary?db=core;g=#{accession}"
      elsif type == 'contig' || type == 'scaffold' || type == 'chromosome'
      	subjstart = encode self.subjstart
      	subjend = encode self.subjend
      	if subjstart > subjend 
      	  subjend = encode self.subjstart
      	  subjstart = self.subjend
      	end
      	url = "#{url}/Location/View?r=#{accession}#{colon}#{subjstart}-#{subjend}"
      end
      #  url ="#{url};j=#{whichdb}"
      {
        :order => 2,
        :title => 'lepbase',
        :url   => url,
        :icon  => 'fa-external-link',
        :img  => 'img/e-lepbase.png'
      }
    end

	def apollo
	  taxa = {}
	  taxa.default = 0
      taxa[:Bicyclus_anynana_nBax0x1] = 16
      taxa[:Bombyx_mori] = 29634
      taxa[:Chilo_suppressalis_CsuOGS1x0] = 73098
      taxa[:Danaus_plexippus] = 153579
      taxa[:Heliconius_melpomene] = 166899
      taxa[:Heliconius_melpomene_Hmel2] = 316443
      taxa[:Lerema_accius_v1x1] = 172007
      taxa[:Manduca_sexta_Msex_1x0] = 201997
      taxa[:Melitaea_cinxia] = 222870
      taxa[:Papilio_glaucus_v1x1] = 231133
      taxa[:Pieris_napi_DAS5] = 275862
      taxa[:Plodia_interpunctella_v1] = 304078
      taxa[:Plutella_xylostella_DBM_FJ_v1x1] = 314622
      return nil unless title.match(TITLE_PATTERN)
      assembly = Regexp.last_match[1]
      key = assembly.gsub('.','x')
      taxid = taxa[key]
      type = Regexp.last_match[2]
      return nil unless type == 'contig' || type == 'scaffold' || type == 'chromosome'
      accession = id
      assembly = encode assembly
      accession = encode accession
      colon = encode ':'
      subjstart = encode self.subjstart
      	subjend = encode self.subjend
      	if subjstart > subjend 
      	  subjend = encode self.subjstart
      	  subjstart = self.subjend
      	end
      url = "http://webapollo.lepbase.org/apollo/annotator/index.html?loc=#{accession}#{colon}#{subjstart}..#{subjend}&organism=#{taxid}&tracks=mRNA"
      
      {
        :order => 2,
        :title => 'web apollo',
        :url   => url,
        :icon  => 'fa-external-link',
        :img  => 'img/e-lepbase.png'
      }
    end


  end
end

# [1]: https://stackoverflow.com/questions/2824126/whats-the-difference-between-uri-escape-and-cgi-escape
