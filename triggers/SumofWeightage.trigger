trigger SumofWeightage on grz_ppt__Progress_Bar_Question__c (before insert,before update) {
    Set<ID> se=new Set<ID>();
    Decimal sum=0;
       if(Trigger.isinsert){
         List<grz_ppt__Progress_Bar_Question__c> pb=[select id,grz_ppt__Weightage__c from grz_ppt__Progress_Bar_Question__c LIMIT 50000];  
            for(grz_ppt__Progress_Bar_Question__c p: pb){
                sum=sum+p.grz_ppt__Weightage__c;
            }
            for(grz_ppt__Progress_Bar_Question__c p : trigger.new){
                sum=sum+p.grz_ppt__Weightage__c; 
                if(sum>100){
                    p.grz_ppt__Weightage__c.addError('The total sum of weightage of all questions should not be greater than 100.');
                }
            }
        }
        if(Trigger.isupdate){
         for(grz_ppt__Progress_Bar_Question__c p : trigger.new){
             se.add(p.id);
         }
         List<grz_ppt__Progress_Bar_Question__c> pb=[select id, grz_ppt__Weightage__c from grz_ppt__Progress_Bar_Question__c where NOT (ID IN:se)];
            for(grz_ppt__Progress_Bar_Question__c p : pb){
             sum=sum+p.grz_ppt__Weightage__c;
         }
            for(grz_ppt__Progress_Bar_Question__c p : trigger.new){
                sum=sum+p.grz_ppt__Weightage__c;
                if(sum>100){
                    p.grz_ppt__Weightage__c.addError('The total sum of weightage of all questions should not be greater than 100.');
                }
            } 
        }    
}