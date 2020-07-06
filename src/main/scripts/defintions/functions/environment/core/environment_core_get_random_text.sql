drop function if exists environment_core_get_random_text;

create or replace function environment_core_get_random_text (
    in in_num_length numeric
)
returns text as $body$
declare
    var_num_offset numeric;
    var_txt_chars text[] := '{0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z}';
    var_txt_result text := '';
begin

    for var_num_offset in
        1 .. in_num_length
    loop

        var_txt_result := var_txt_result || var_txt_chars [1 + random () * (array_length (var_txt_chars, 1) - 1)];

    end loop;

    return var_txt_result;

end;
$body$ language plpgsql;