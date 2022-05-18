function xyz_fixed = getBadContacts(xyz,rco)

    % Need to find contacts that are too close ->
    
    % OR if they have 2 contacts in the same direction ( remove the closer
    % one)
    
    
    dx = xyz(:,1) - xyz(:,1)';
    dy = xyz(:,2) - xyz(:,2)';
    dz = xyz(:,3) - xyz(:,3)';
    
    N = length(xyz(:,1));
    
    IDs = 1:N;
    goodContacts = true(N,1);
    
    % Number of contacts
    adj = ((dx.*dx + dy.*dy + dz.*dz <= rco*rco) - eye(N)) > 0;
    
    for i = 1:N
        
        
        % Get the neighbor ID
        nbrs = IDs(adj(i,:));
        % Get the orientation of the neighbors contacts ( they must all be
        % no more than 60 degrees away from each other)
        numNbrs = length(nbrs);
        
        
        dxij   = xyz(adj(i,:),1) - xyz(i,1);
        dyij   = xyz(adj(i,:),2) - xyz(i,2);
        dzij   = xyz(adj(i,:),3) - xyz(i,3);
        
        dMag = sqrt(dxij.*dxij + dyij.*dyij + dzij.*dzij);
        dxij = dxij./dMag;
        dyij = dyij./dMag;
        dzij = dzij./dMag;
        
        for j = 1:numNbrs
            
            dProd = dxij(j)*dxij + dyij(j)*dyij + dzij(j)*dzij;
            
            if(~isempty(dProd(j) - dProd > 1.80))
                if(sum(dMag(dProd(j) - dProd > 1.80) <= 22)==2)
                    if(dMag(j) <= 22)
                        goodContacts(i) = false;
                    end
                end
            end
                
        end
        
%         if(sum(dMag <= 21) == 3)
%             goodContacts(i) = false;
%         end
        
    end
        
    xyz_fixed = xyz(goodContacts,:);
    
    N = length(xyz_fixed);
    
    goodContacts = true(N,1);
    for i = 1:N
        
        
        % Get the neighbor ID
        % Get the orientation of the neighbors contacts ( they must all be
        % no more than 60 degrees away from each other)

        
        dxij   = xyz_fixed(:,1) - xyz_fixed(i,1);
        dyij   = xyz_fixed(:,2) - xyz_fixed(i,2);
        dzij   = xyz_fixed(:,3) - xyz_fixed(i,3);
        
        dMag = sqrt(dxij.*dxij + dyij.*dyij + dzij.*dzij);
        
        if(sum(dMag <= 21) == 4)
            goodContacts(i) = false;
        end
    end
    xyz_fixed = xyz_fixed(goodContacts,:);
    
    disp(N);
    disp(sum(goodContacts));
end