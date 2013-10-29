{application, counters,
 [
  {description, ""},
  {vsn, "1.1.1"},
  {modules, [
            
             counters_app,
             counters_sup,
             counter_store,
             counter,
             counters
            ]},
  {registered, [counters_sup]},
  {applications, [
                  kernel,
                  stdlib
                 ]},
  {mod, {counters_app,[]}}
 ]}.