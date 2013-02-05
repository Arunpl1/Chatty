App.Message = DS.Model.extend
  user: DS.belongsTo('App.User')
  body: DS.attr('string')
