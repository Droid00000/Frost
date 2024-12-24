# frozen_string_literal: true

def steal_snowball(data)
  unless CONFIG['Discord']['CONTRIBUTORS'].include?(data.user.id)
    data.edit_response(content: RESPONSE[12])
    return
  end

  if Frost::Snow.snowballs(data) < data.options['amount']
    data.edit_response(content: RESPONSE[21])
    return
  end

  unless Frost::Snow.snowball?(data, true)
    data.edit_response(content: RESPONSE[16])
    return
  end

  Frost::Snow.user(data)

  Frost::Snow.steal(data) 

  data.edit_response(content: format(RESPONSE[31], data.options['amount']))
end
