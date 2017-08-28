module VCL
  # Contains some reusable functions that don't fit elsewhere
  module Utils
    def self.open_service(id)
      Launchy.open(VCL::FASTLY_APP + VCL::TANGO_PATH + id)
    end

    def self.parse_directory(path = false)
      directory = Dir.pwd unless path
      directory = path if path

      id = directory.match(/.* \- ([^\-]*)$/i)
      id = id.nil? ? false : id.captures[0]

      id
    end

    def self.parse_name(path = false)
      directory = Dir.pwd unless path
      directory = path if path

      name = directory.match(/(.*) \- [^\-]*$/i)
      name = name.nil? ? false : name.captures[0]

      name
    end

    def self.get_diff(old_vcl, new_vcl)
      options = {
        include_diff_info: true,
        diff: ['-E', '-p'],
        context: 3
      }
      Diffy::Diff.new(old_vcl, new_vcl, options).to_s(:color)
    end

    def self.diff_generated(v1, v2)
      diff = ''

      diff << "\n" + get_diff(v1['content'], v2['content'])

      diff
    end

    def self.diff_versions(v1 = [], v2 = [])
      diff = ''
      v1.each do |vcl1|
        v2_content = false

        v2.each do |vcl2|
          v2_content = vcl2['content'] if vcl1['name'] == vcl2['name']
          if v2_content
            vcl2['matched'] = true
            break
          end
        end

        v2_content = '' unless v2_content

        diff << "\n" + get_diff(vcl1['content'], v2_content)
      end

      v2.each do |vcl|
        diff << "\n" + get_diff('', vcl['content']) unless vcl.key? 'matched'
      end

      diff
    end

    def self.make_dot_dir
      Dir.mkdir(File.basename(VCL::CREDENTIALS)) unless
        Dir.exist?(File.basename(VCL::CREDENTIALS))
    end
  end
end
