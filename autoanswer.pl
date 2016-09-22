use Purple;

%PLUGIN_INFO = (
    perl_api_version => 2,
    name => "Auto Answer (Romanian)",
    version => "0.1",
    summary => "Simple and hardcoded autoanswer plugin for pidgin",
    description => "Simple and hardcoded autoanswer plugin for pidgin",
    author => "cipibad",
    url => "",
    load => "plugin_load",
    unload => "plugin_unload",
);



sub plugin_init {
    return %PLUGIN_INFO;
}

sub plugin_load {
    $plugin = shift;

    Purple::Debug::info("autoanswer", "plugin_load() - begin\n");

    # A pointer to the handle to which the signal belongs
    $convs_handle = Purple::Conversations::get_handle();
    Purple::Debug::info("autoanswer", "Purple::Conversations::get_handle() - " . ($convs_handle ? "ok." : "fail.") . "\n");
    
    Purple::Signal::connect($convs_handle, "wrote-im-msg", $plugin, \&wrote_im_msg_cb, "yyy");

    Purple::Debug::info("autoanswer", "plugin_load() - autoanswer plugin loaded\n");

}

sub plugin_unload {
    my $plugin = shift;
    Purple::Debug::info("autoanswer", "plugin_unload() - autoanswer plugin unloaded.\n");
}


sub wrote_im_msg_cb {
    my ($account, $who, $msg, $conv, $flags) = @_;

    if ($flags & 1 ) 
    {
        Purple::Debug::info("autoanswer", "ignoring messages we sent message\n");
        return;
    }

    $msg  =~ s/<[^>]*>//g;
    $msg  =~ s/&nbsp;//g;
    
    $lang = "-v ro";
    $says = "spune";
    #following code should be part of something smarter ...
    $autoAnswer = 0;
    $answerMsg = "";
    
    #intro
    if ( $msg =~ /ce.*faci.*/i )
    {
        $autoAnswer = 1;
        $answerMsg = "Eu fac bine, tu ce mai faci?";
    }
    
    if ( $msg =~ /c[ie]a[ou]/i )
    {
        $autoAnswer = 1;
        $answerMsg = "Ceau.";
    }
    
    if ( $msg =~ /hello/i )
    {
        $autoAnswer = 1;
        $answerMsg = "Hello.";
    }
    if ( $msg =~ /Salut/i )
    {
        $autoAnswer = 1;
        $answerMsg = "Salut.";
    }
    if ( $msg =~ /Buna/i )
    {
        $autoAnswer = 1;
        $answerMsg = "Buna.";
    }
    
    if ( $msg =~ /hi /i )
    {
        $autoAnswer = 1;
        $answerMsg = "Hi.";
    }
    
    
    #other
    if ( $msg =~ /rezolvat/i )
    {
        $autoAnswer = 1;
        $answerMsg .= " E on-going ...";
    }
    
    if ( $msg =~ /vii.*mine/i )
    {
        $autoAnswer = 1;
        $answerMsg .= " Incerc ...";
    }
    
    #end
    if ( $msg =~ / no /i )
    {
        $autoAnswer = 1;
        $answerMsg .= " Incerc ...";
    }
    
    if ( $msg =~ /merci/i || $msg =~ /ms/i  || $msg =~ /multu/i )
    {
        $autoAnswer = 1;
        $answerMsg .= "Cu placere.";
    }
    
    if ( $msg =~ /bye/i )
    {
        $autoAnswer = 1;
        $answerMsg .= "Bye.";
    }
    
    
    
    if ( $autoAnswer ) {
        $im = $conv->get_im_data();
        if ($im) 
        {
            $im->send($answerMsg."(a)");
        } else { 
            Purple::Debug::info("autoanswer", "$conv->get_im_data() \n");
        }
    }
}


