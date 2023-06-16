function ListLUBnew = updateLUB3(ListLUB,z,tolerance)
%updateLUB3 Updates the list of local upper bounds
% This function is an implementation of Algorithm 3 from:
% K. Klamroth et al., On the representation of the search region in
% multi-objective optimization

%% Initialization
p = size(z,1);
if nargin < 4
    tolerance = 1e-6;
end

% A is the set off all search zones {u}-K that contain z
A_indexlist = all(bsxfun(@lt,z,ListLUB));
A = ListLUB(:,A_indexlist);
sizeA = size(A,2);

B = cell(1,p);
P = cell(1,p);

%% Update procedure
for j=1:p
    % B(j) contains all search zones whose boundary contains z with respect
    % to the j-th component (u_j = z_j)
    B{j} = ListLUB(:,all([bsxfun(@lt,z(1:j-1),ListLUB(1:j-1,:));...
                bsxfun(@eq,z(j),ListLUB(j,:));...
                bsxfun(@lt,z(j+1:p),ListLUB(j+1:p,:))]));
            
    % P(j) contains the projections of z on all local upper bounds in A
    % along the j-th dimension / component
    P{j} = [A(1:j-1,:);z(j).*ones(1,sizeA);A(j+1:p,:)];
end

% The following loop filters all redundant points out of P(j) for every
% j=1:p where redundant bascially means dominated
P_indexlist = false(p,sizeA);
for j=1:p
    Pj = P{j};
    PB = [Pj B{j}];
    for i=1:sizeA
        P_indexlist(j,i) = ~any(all([all(bsxfun(@le,Pj(:,i),PB));any(bsxfun(@lt,Pj(:,i),PB))]));
    end
    P{j} = Pj(:,P_indexlist(j,:));
end

% P is transformed from a cell array to a matrix
P = [P{1:p}];

% The new list of local upper bounds is computed and made unique
ListLUBnew = unique([ListLUB(:,~A_indexlist),P]','rows')';
end