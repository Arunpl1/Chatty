App.Adapter = DS.RESTAdapter.extend
  find: (a,b,c) ->
    return null


App.Adapter.map 'App.Message', 
  user:
    embedded: 'always'
  body:
    key: 'message' 

App.Store = DS.Store.extend
  revision: 11
  adapter: App.Adapter.create()
