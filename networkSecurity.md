# 一、 步骤
1. 大素数 p,q
2. n = p * q
$$ 
欧拉函数  \quad  \phi (n)= (p-1) * (q-1)
$$

3. 
$$
1 < e < \phi (n)  
$$
令    
$$ 使其互质 \quad gcd(e, \phi(n) )  = 1 $$
4. 计算d 使  
$$ de = 1 mod \quad \phi(n) $$

5. 密钥 k = (n , p, q, d, e), 定义加密变换为 Ek(x) = xe mod n,  解密变换为 Dk(x)= yd mod n ,  
$$ x,y \in Z(n) $$

6. 以 {e,n} 为公开密钥,{p,q,d}为私有密钥.


