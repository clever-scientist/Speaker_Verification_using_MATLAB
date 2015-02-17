clc;

l1=length(post{1,1});
l2=length(post{1,2});
lt=length(post_t);
lf=min(l1,l2);
l=min(lf,lt);
d1=post_t(1:l,:)-post{1,1}(1:l,:);
d2=post_t(1:l,:)-post{1,2}(1:l,:);
dsq1=d1.^2;
dsq2=d2.^2;
s1=sum(dsq1)
s2=sum(dsq2)

x=sum(s1)
y=sum(s2)