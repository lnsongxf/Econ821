function [cPolM, kPolM, v_kjaM] = hh_solve(R, w, transferV, paramS, cS)
% Solve hh problem
%{
IN:
 R = 1+r, w
    Household prices
 transferV
    Lump-sum transfers by age

OUT:
   cPolM, kPolM
      Consumption and savings functions
      by [ik, ie, age]
   v_kjaM
      value function
%}


%% Main

% Initialize policy function by [ik, ie, age]
sizeV = [cS.nk, cS.nw, cS.aD];
cPolM = nan(sizeV);
kPolM = nan(sizeV);
v_kjaM = nan(sizeV);


% Backward induction
for a = cS.aD : -1 : 1
   % Next period consumption function
   if a < cS.aD
      vPrime_kjM = paramS.beta .* v_kjaM(:,:,a+1);
   else
      % There is no next period
      vPrime_kjM = [];
   end

   [cPolM(:,:,a), kPolM(:,:,a), v_kjaM(:,:,a)] = ...
      hh_ogm.hh_solve_age(a, vPrime_kjM, R, w, transferV(a), paramS, cS);
end


%% Output check
if cS.dbg > 10
   validateattributes(cPolM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
      'size', sizeV})
   validateattributes(kPolM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      'size', sizeV, '>=', cS.kMin, '<=', paramS.kGridV(end)})
   validateattributes(v_kjaM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real',  ...
      'size', sizeV})
end

end