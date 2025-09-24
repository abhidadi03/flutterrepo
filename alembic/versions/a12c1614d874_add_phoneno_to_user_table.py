"""add_phoneno_to_user_table

Revision ID: a12c1614d874
Revises: 4f8226a8a83f
Create Date: 2025-09-17 18:43:32.350933

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = 'a12c1614d874'
down_revision: Union[str, Sequence[str], None] = '4f8226a8a83f'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    op.add_column('user',sa.Column('phone_no',sa.String(), nullable=True))
    pass


def downgrade() -> None:
    """Downgrade schema."""
    op.drop_column("user","phone_no")
    pass
