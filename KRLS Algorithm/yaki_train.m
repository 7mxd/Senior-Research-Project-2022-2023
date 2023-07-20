function [basis_states, Alpha, kp] = yaki_train( kfunc, kparam, ald_thresh, training_states, target )

  [n training_cnt] = size( training_states );

  kp = krls_init( kfunc, kparam, ald_thresh, training_states( :, 1), target(1) );

  for i = 2:training_cnt
    kp = krls( kp, training_states( :, i), target(i) );
  end;
 
  %
  % Complicated Yaki scheme
  %
 
  nextcol = training_cnt+1;
  startset = 1;
  tmpcnt = training_cnt-1;
 
  dcnt = 5;
  for dd = 1:dcnt
    %fprintf( 2, '%d', dd );

  %  fprintf( '  Yaki iter %d...\n', dd );
 
    Rmat = feval( kfunc, training_states, kp.dp.Dict, kparam );
    newt = Rmat * kp.Alpha;
 
    for i=startset:startset+tmpcnt-1
      % construct a new training state
      ut = training_states(:,i);
      newut = [ut(2:n); newt(i)];
      newtarg = target(i+1);
 
      training_states( :,nextcol ) = newut;
      target(nextcol) = newtarg;
 
      kp = krls( kp, newut, newtarg );
 
  %    fprintf( '    Example %d [%d]\n', nextcol, kp.addedFlag );
 
      nextcol = nextcol + 1;
    end;
    startset = startset + tmpcnt + 1;
    tmpcnt = tmpcnt-1;
 
  end;

  basis_states = kp.dp.Dict;
  Alpha = kp.Alpha;

return;
