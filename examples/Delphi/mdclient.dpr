program mdclient;
//
//  Majordomo Protocol client example
//  Uses the mdcli API to hide all MDP aspects
//  @author Varga Balázs <bb.varga@gmail.com>
//
{$APPTYPE CONSOLE}

//  Lets us build this source without creating a library

uses
    SysUtils
  , mdcliapi
  , zmqapi
  , zhelpers
  ;

var
  verbose: Integer;
  session: TMajorDomoClient;
  count: Integer;
  request,
  reply: TZMQMsg;
begin
  if ( ParamCount > 0 ) and ( ParamStr( 1 ) = '-v' ) then
    verbose := 1
  else
    verbose := 0;

  session := TMajorDomoClient.Create( 'tcp://localhost:5555', verbose );
  count := 0;
  while ( count < 100000 ) do
  begin
    request := TZMQMsg.Create;
    request.pushstr( 'Hello world' );
    reply := session.send( 'echo', request );
    if reply <> nil then
      reply.Free
    else
      break; //  Interrupt or failure
    inc( count );
  end;
  zNote( Format( '%d requests/replies processed', [count] ) );
  session.Free;
end.

