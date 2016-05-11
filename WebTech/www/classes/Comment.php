<?php
	require_once('Template.php');
	require_once('SiteInfo.php');
	
	class Comment extends Template
	{
		private $authorId;
		private $authorName;
		private $authorAvatar;
		private $commentText;
		private $commentDate;
		
		public function __construct($author, $authorId, $text, $date, $avatar)
		{
			parent::__construct('comment_body');
			
			$this->authorId = $authorId;
			$this->authorName = $author;
			$this->authorAvatar = $avatar;
			$this->commentText = $text;
			$this->commentDate = $date;
		}
		
		protected function handleKeywords()
		{
			$this->replaceKeywordByText('USERNAME', $this->authorName);
			$this->replaceKeywordByText('USERNAME_LINK', SiteInfo::getAuthorLink($this->authorId));
			$this->replaceKeywordByText('USER_AVATAR', $this->authorAvatar);
			$this->replaceKeywordByText('COMMENT_TEXT', $this->commentText);
			$this->replaceKeywordByText('CREATION_DATE', $this->commentDate);
		}
	}
?>