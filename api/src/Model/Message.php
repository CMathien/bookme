<?php

namespace Bookme\API\Model;

use Bookme\API\Component\Model\Model;

class Message extends Model
{
    private int $id;
    private string $content;
    private \DateTime $date;
    private User $sender;
    private User $recipient;

    public function getId()
    {
        return $this->id;
    }

    public function setId($id)
    {
        $this->id = $id;

        return $this;
    }

    public function getContent()
    {
        return $this->content;
    }

    public function setContent($content)
    {
        $this->content = $content;

        return $this;
    }

    public function getDate()
    {
        return $this->date;
    }

    public function setDate($date)
    {
        $this->date = $date;

        return $this;
    }

    public function getSender()
    {
        return $this->sender;
    }

    public function setSender($sender)
    {
        $this->sender = $sender;

        return $this;
    }

    public function getRecipient()
    {
        return $this->recipient;
    }

    public function setRecipient($recipient)
    {
        $this->recipient = $recipient;

        return $this;
    }

    public function toArray(): array
    {
        if ($this->isInitialized("id")) $array['id'] = $this->getId();
        if ($this->isInitialized("content")) $array['content'] = $this->getContent();
        if ($this->isInitialized("date")) $array['date'] = $this->getDate()->format("Y-m-d");
        if ($this->isInitialized("sender")) $array['sender'] = $this->getSender()->getId();
        if ($this->isInitialized("recipient")) $array['recipient'] = $this->getRecipient()->getId();
        return $array;
    }
    public function isInitialized($param)
    {
        $rp = new \ReflectionProperty('Bookme\API\Model\Message', $param);
        return $rp->isInitialized($this);
    }
}
